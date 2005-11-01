From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: latest device-mapper cvs @ 1.02.00, but latest
	multipath-tools requires 01.03.00 ?
Date: Tue, 01 Nov 2005 08:47:19 +0100
Message-ID: <1130831239.349.8.camel@zezette>
References: <35D744B011AD9A4A86B5962E85181C78027AB668@caex02.trans.corp>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <35D744B011AD9A4A86B5962E85181C78027AB668@caex02.trans.corp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On lun, 2005-10-31 at 16:39 -0800, Brian Wong wrote:
> Hi,
> 
> Has anyone else run into this problem?
> 
> The latest multipath tools explicitly requires a device mapper that
> reports a version of at least 1.3.0, but the latest cvs snapshot of
> device-mapper reports 1.02.00-cvs, at least according to 'dmsetup
> version' of the dmsetup in my cvs tree.
> 
the tools need multipath target version >1.0.3.
this is not the core devmapper version.

xa-s05:~/scm/multipath-tools-0.4.6# dmsetup targets
multipath        v1.0.4
striped          v1.0.2
linear           v1.0.1
error            v1.0.1

xa-s05:~/scm/multipath-tools-0.4.6# dmsetup version
Library version:   1.01.05 (2005-09-26)
Driver version:    4.4.0

> I used the following to pull the latest device-mapper tree:
> 
> cvs -d :pserver:cvs@sources.redhat.com:/cvs/dm checkout device-mapper
> 
> Is there a more recent version of device-mapper that I'm not aware of?
> 
> sneezy:/nfs/cadv05-misc/bwong/bwong-git-multipath-tools #
> multipath/multipath -d
> multipath       multipath
> 1,0,2   1,0,3
> DM multipath kernel driver version too old
> sneezy:/nfs/cadv05-misc/bwong/bwong-git-multipath-tools #
> 
You need to upgrade the kernel side, not the lib.

Regards,
cvaroqui
