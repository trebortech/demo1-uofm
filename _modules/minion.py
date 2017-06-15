# -*- coding: utf-8 -*-
'''
Module to provide information about minions
'''
from __future__ import absolute_import

# Import Salt libs
import salt.utils


def rollback(package=None):

    if package = None:
        return "You need to supply the package path that you would like to install"

    saltminion = {}
    saltminion['saltminion'] = package
    sources = [saltminion]
    ret = __salt__['pkg.install'](sources=sources)

    return ret
