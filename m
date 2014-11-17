From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dmcache RAID1 bug?
Date: Mon, 17 Nov 2014 09:46:59 -0500
Message-ID: <20141117144659.GA29929@redhat.com>
References: <CAEZ+n-i7kOC3zZzrv5GHbmfuKJ3b1U6COG8DyDW8HjHk9wDf-Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAEZ+n-i7kOC3zZzrv5GHbmfuKJ3b1U6COG8DyDW8HjHk9wDf-Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Leonardo Santos <heiligerstein@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 17 2014 at  9:24am -0500,
Leonardo Santos <heiligerstein@gmail.com> wrote:

> I'm working in tests for my msc thesis envolving dm_cache module. I'm
> having problems with the following scenario:
> 
> Slowstorage: RAID1 (mdadm) with 4 HDDs;
> - /dev/md/raid1_4ssds

You mean /dev/md/raid1_4hdds ?

> -- /dev/sda
> -- /dev/sdb
> -- /dev/sdc
> -- /dev/sdd
> 
> Faststorage: RAID1 (mdadm) with 4 SSDs
> - /dev/md/raid1_4hdds

And /dev/md/raid1_4ssds here?

> -- /dev/sde
> -- /dev/sdf
> -- /dev/sdg
> -- /dev/sdh
>
> 
> Cachestorage: dm_cache envolving both devices
> - /dev/mapper/dmcache
> -- /dev/md/raid1_4ssds
> -- /dev/md/raid1_4hdds
> 
> Other informations (strange facts):
> In RAID0 it's working very well.
> In a virtual machine (vbox) it's working as well (in this case disks have
> 2GB only for big tests automatization, in production are 160GB SSDs and 2TB
> HDDs);
> 
> Have you seen about this error? Syslog is bellow.

Never seen this before... have you taken care to zero the dm-cache
metadata's superblock (first 512B of the cache metadata device) each
time you've reconfigured the cache device?

Have you tried using the latest lvm2 to create the dm-cache device?
