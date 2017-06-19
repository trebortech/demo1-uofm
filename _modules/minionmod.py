# -*- coding: utf-8 -*-
'''
Module to provide information about minions
'''
from __future__ import absolute_import

# Import Salt libs
import salt.utils

__virtualname__ = 'minionmod'


def __virtual__():
    return __virtualname__


def _tasks(cmd):

    if salt.utils.is_windows():
        '''
        Due to problems when installing when service is running I utilized
        schtasks to schedule the install.
        '''
        minioninstall = []
        minioninstall.append(r"$ts = (get-date).addminutes(1).tostring('HH:mm')")
        minioninstall.append(r"schtasks.exe /create /RU SYSTEM /SC ONCE /ST $ts /TN reinstallsalt /TR '{0}' /F".format(cmd))
        minioncommand = ';'.join(minioninstall)
        ret = __salt__['cmd.run'](minioncommand, shell='powershell', python_shell=True)
    else:
        command = 'echo {0} | at now + 1 minute'.format(cmd)
        ret = __salt__['cmd.run'](command, python_shell=False)
    return True


def install(package=None, common=None):

    if package is None:
        return "You need to supply the package path that you would like to install"
    saltminion = {'saltminion': package}

    if salt.utils.is_windows():
        # copy file over
        __salt__['cp.get_file'](package, "c:\\salt\\var\\cache\\salt-minion.exe")

        cmdinstall = "c:\\salt\\var\\cache\\salt-minion.exe /S"
        ret = _tasks(cmdinstall)
    else:
        if common:
            saltcommon = {'saltcommon': common}
            sources = [saltcommon, saltminion]
        else:
            sources = [saltminion]
        ret = __salt__['pkg.install'](sources=sources)
        cmdinstall = 'service salt-minion restart'
        ret = _tasks(cmdinstall)
    return ret


def restart(service):

    if salt.utils.is_windows():
        cmdrestart = "restart-service {0}".format(service)
    else:
        cmdrestart = "service {0} restart".format(service)
    ret = _tasks(cmdrestart)
    return ret
