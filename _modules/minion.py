# -*- coding: utf-8 -*-
'''
Module to provide information about minions
'''
from __future__ import absolute_import

# Import Salt libs
import salt.utils


def rollback(package=None, common=None):

    if package is None:
        return "You need to supply the package path that you would like to install"

    saltminion = {'saltminion': package}
    saltcommon = {'saltcommon': common}
    sources = [saltminion, saltcommon]
    ret = __salt__['pkg.install'](sources=sources)

    return ret
