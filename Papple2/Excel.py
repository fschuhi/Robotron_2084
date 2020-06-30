#!/usr/bin/env python

import xlwings as xw

def raise_error(s):
    raise ExcelException(s)


class ExcelException(Exception):
    pass


class ExcelContext:

    @property
    def result(self):
        return self.__result

    @result.setter
    def result(self, r):
        self.__result = r

    def __enter__(self):
        self.__result = None
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type is None:
            pass
        else:
            if exc_type == ExcelException:
                self.result = "#" + str(exc_val)
                return True


