From: Sahid Orentino Ferdjaoui <sahid.ferdjaoui@canonical.com>
Subject: Re: Where to read the WWID of a multipath device
Date: Thu, 21 Mar 2019 10:06:45 +0100
Message-ID: <20190321090645.GA19597@canonical>
References: <20190320102805.GA30538@canonical>
	<CAKROqvcrwnvfLpmW2Z42q20djgGi+pzzHi4y+Wu6+O21Fd4m8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKROqvcrwnvfLpmW2Z42q20djgGi+pzzHi4y+Wu6+O21Fd4m8Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Russell Weber <rustyscottweber@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Mar 21, 2019 at 01:57:39AM -0600, Russell Weber wrote:
> I would assume that most linux distributions at this point in time support
> getting the wwids through:
> ```cat /etc/multipath/wwids````

This path can be changed via multipath.conf I can't really use
it. Also I just have a list of connected volumes ['sda', 'sdb'...] and
the multipath device 'dm-0'.

> This can also be parsed out of multipath -ll
> ```
> [USER ~]# multipath -ll
> mpathak (26639613661623365) dm-3 FUSIONIO,ION LUN
> size=2.7T features='3 queue_if_no_path pg_init_retries 50' hwhandler='1
> alua' wp=rw
> |-+- policy='queue-length 0' prio=50 status=active
> | |- 7:0:0:1  sdb 8:16 active ready running
> | `- 8:0:0:1  sdc 8:32 active ready running
> `-+- policy='queue-length 0' prio=1 status=enabled
>   |- 9:0:0:1  sdd 8:48 active ready running
>   `- 10:0:0:1 sde 8:64 active ready running
> [USER ~]# cat /etc/multipath/wwids | grep -i 26639613661623365
> /26639613661623365/

I would like avoid such parsing if possible.

> However, I'm curious as to why you would need the wwid as most higher level
> python management libraries I've worked with are much more concerned with
> the disk or partition GUID,  LUN number, or some other ID for the disk.
> Example:
> ```
> [USER by-uuid]# ls -al
> total 0
> drwxr-xr-x. 2 root root 120 Mar 20 14:58 .
> drwxr-xr-x. 5 root root 100 Mar 20 14:58 ..
> lrwxrwxrwx. 1 root root  10 Mar 21 00:04
> 5b1c21dc-6f65-4d88-99a0-b30f76d08931 -> ../../dm-2
> lrwxrwxrwx. 1 root root  10 Mar 21 00:04
> 72e5d3ab-d4b2-4d0a-8b77-ba9dd718871c -> ../../sda1
> lrwxrwxrwx. 1 root root  10 Mar 21 00:04
> df4b2a63-4a56-4173-ba82-45f567d1b5bf -> ../../dm-0
> lrwxrwxrwx. 1 root root  10 Mar 21 00:04
> fa3c2abb-d8d2-4a99-84d2-09f8204e429e -> ../../dm-1
> [USER by-uuid]# pwd
> /dev/disk/by-uuid
> 
> ```
> What do you need the WWID for as the multipath wwid may not be the best
> option for the application you are looking at?

Yes the WWN is probably used as metadata but the API is asking for it.

Usually we get the WWN from the sysfs entries in
/dev/disk/by-id/scsi-* (context is iSCSI connected volumes). But
algorithm has a bug if the multipath device is generated automatically
and the devnames are not anymore in sysfs.

We are able to find the multipath device by looking at
/sys/block/{devnames}/holders/dm-*

I don't say the algorithm if perfect, I can't really update
everything. So the question is really related to how get the WWN from
the multipath device name in a accurate way.

> On Wed, Mar 20, 2019 at 4:28 AM Sahid Orentino Ferdjaoui <
> sahid.ferdjaoui@canonical.com> wrote:
> 
> > Hi,
> >
> > The question is as indicated on title, what would be the best way to
> > get the WWID of a multipath device, something which would work on any
> > systems or storages.
> >
> > My idea was to read /sys/block/dm-X/name but someone indicated to me
> > that may not be correct in some situation, like it seems that
> > /lib/udev/scsi_id would not be correct either.
> >
> > To give a bit of context it's for an OpenStack library in Python.
> >
> > Thanks,
> > s.
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
