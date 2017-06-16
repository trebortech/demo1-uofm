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


def install(package=None, common=None):

    if package is None:
        return "You need to supply the package path that you would like to install"
    saltminion = {'saltminion': package}

    if salt.utils.is_windows():
        # copy file over
        __salt__['cp.get_file'](package, "c:\\salt\\var\\cache\\salt-minion.exe")

        '''
        Due to problems when installing when service is running I utilized
        schtasks to schedule the install.
        '''
        minioninstall = []
        cmdinstall = "c:\\salt\\var\\cache\\salt-minion.exe /S"
        minioninstall.append(r"$ts = (get-date).addminutes(1).tostring('HH:mm')")
        minioninstall.append(r"schtasks.exe /create /RU SYSTEM /SC ONCE /ST $ts /TN reinstallsalt /TR '{0}' /F".format(cmdinstall))
        minioncommand = ';'.join(minioninstall)
        ret = __salt__['cmd.run'](minioncommand, shell='powershell', python_shell=True)
    else:
        if common:
            saltcommon = {'saltcommon': common}
            sources = [saltcommon, saltminion]
        else:
            sources = [saltminion]
        ret = __salt__['pkg.install'](sources=sources)

    if not salt.utils.is_windows():
        command = 'echo service salt-minion restart | at now + 1 minute'
        ret = __salt__['cmd.run'](command)

    return ret
