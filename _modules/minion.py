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


def rollback(package=None, common=None):

    if package is None:
        return "You need to supply the package path that you would like to install"
    saltminion = {'saltminion': package}

    if salt.utils.is_windows():
        sources = [saltminion]
    else:
        saltcommon = {'saltcommon': common}
        sources = [saltcommon, saltminion]

    ret1 = __salt__['pkg.install'](sources=sources)

    if salt.utils.is_windows():
        restartcmd = []
        restartcmd.append(r"$ts = (get-date).addminutes(1).tostring('H:mm')")
        restartcmd.append(r"schtasks.exe /create /SC ONCE /ST $ts /TN restartsalt /TR 'restart-service salt-minion'")
        command = ';'.join(restartcmd)
    else:
        command = 'echo service salt-minion restart | at now + 1 minute'

    ret2 = __salt__['cmd.run'](command)

    return ret1 + ret2
