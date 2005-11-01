From: "Brian Wong" <bwong@pillardata.com>
Subject: latest device-mapper cvs @ 1.02.00,
	but latest multipath-tools requires 01.03.00 ?
Date: Mon, 31 Oct 2005 16:39:04 -0800
Message-ID: <35D744B011AD9A4A86B5962E85181C78027AB668@caex02.trans.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

Has anyone else run into this problem?

The latest multipath tools explicitly requires a device mapper that
reports a version of at least 1.3.0, but the latest cvs snapshot of
device-mapper reports 1.02.00-cvs, at least according to 'dmsetup
version' of the dmsetup in my cvs tree.

I used the following to pull the latest device-mapper tree:

cvs -d :pserver:cvs@sources.redhat.com:/cvs/dm checkout device-mapper

Is there a more recent version of device-mapper that I'm not aware of?

sneezy:/nfs/cadv05-misc/bwong/bwong-git-multipath-tools #
multipath/multipath -d
multipath       multipath
1,0,2   1,0,3
DM multipath kernel driver version too old
sneezy:/nfs/cadv05-misc/bwong/bwong-git-multipath-tools #

Thanks,

Brian
