From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tools: [cppcheck] static code analysis
Date: Thu, 21 Jul 2016 14:40:46 +0200
Message-ID: <55e832d0-f8ed-9cbc-1ca5-593c94f343bb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, ShivaKrishna Merla <shivakrishna.merla@netapp.com>
List-Id: dm-devel.ids

ShivaKrishna, could you please check the first two errors(Division by zero).
That code was added in a28e61e5

[libmultipath/configure.c:179]: (error) Division by zero.
[libmultipath/configure.c:197]: (error) Division by zero.
[libmultipath/print.c:800]: (error) Expression 'while((int)(c-s)<(data.width)&&(c<(line+len-1)))*c++' depends on order of evaluation of side effects
[libmultipath/print.c:835]: (error) Expression 'while((int)(c-s)<(data.width)&&(c<(line+len-1)))*c++' depends on order of evaluation of side effects
[libmultipath/print.c:867]: (error) Expression 'while((int)(c-s)<(data.width)&&(c<(line+len-1)))*c++' depends on order of evaluation of side effects
[libmultipath/print.c:902]: (error) Expression 'while((int)(c-s)<(data.width)&&(c<(line+len-1)))*c++' depends on order of evaluation of side effects
[libmultipath/print.c:936]: (error) Expression 'while((int)(c-s)<(data.width)&&(c<(line+len-1)))*c++' depends on order of evaluation of side effects
[libmpathcmd/mpath_cmd.h:24]: (error) Invalid number of character '{' when these macros are defined: '__cpluscplus'.

[kpartx/kpartx.c:70]: (portability) Assigning an integer to a pointer is not portable.
[libmultipath/log.c:58]: (portability) 'la.start' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined.
[libmultipath/log.c:119]: (portability) 'la.tail' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined.
[libmultipath/devmapper.c:1050]: (portability) '(void*)names' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined.
[libmultipath/devmapper.c:1200]: (portability) '(void*)names' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined.
[libmultipath/devmapper.c:891]: (portability) '(void*)names' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined.
[libmultipath/devmapper.c:162]: (portability) '(void*)target' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined.

[libmultipath/alias.c:54] -> [libmultipath/alias.c:55]: (performance) Buffer 'name' is being written before its old content has been used.


[0] http://cppcheck.sf.net/
