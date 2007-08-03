From: Luca Berra <bluca@comedia.it>
Subject: Re: [linux-lvm] Re: LVM on dmraid breakage
Date: Fri, 3 Aug 2007 09:55:56 +0200
Message-ID: <20070803075556.GA939@percy.comedia.it>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B1B5E1.1050406@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B1B5E1.1050406@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 02, 2007 at 11:45:53AM +0100, Bryn M. Reeves wrote:
>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>Luca Berra wrote:
>> Two things come to mind
>> 1) dmraid should use ioctl BLKPG_DEL_PARTITION, to clean up any eventual
>> partition table on component devices
>> 
>> 2) lvm tool filter could be modified to check if a device has been
>> already claimed by device-mapper.
>> 
>
>But device-mapper already opens devices exclusively when a target claims
>them.

No, it does not,
sorry

[root@localhost ~]# dmsetup create foobar
0 281329664 linear /dev/md2 0
[root@localhost ~]# dmsetup table
foobar: 0 281329664 linear 9:2 0
[root@localhost ~]# dmsetup create foobar1
0 281329664 linear /dev/md2 0
[root@localhost ~]# dmsetup create foobar2
0 281329664 linear /dev/md2 0
[root@localhost ~]# dmsetup create foobar2
0 281329664 linear /dev/md2 0
[root@localhost ~]# dmsetup table
foobar3: 0 281329664 linear 9:2 0
foobar2: 0 281329664 linear 9:2 0
foobar1: 0 281329664 linear 9:2 0
foobar: 0 281329664 linear 9:2 0

L.
-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
