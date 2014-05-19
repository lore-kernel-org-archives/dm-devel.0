From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: thin_repair doesn't do size checking on the output
 device
Date: Mon, 19 May 2014 09:37:12 +0200
Message-ID: <5379B4A8.6050501@redhat.com>
References: <CAAYit8QKG_gAmwvew7AAZMJeSh5MzGtuMrRrk9Gi-BS2UcyAUQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAYit8QKG_gAmwvew7AAZMJeSh5MzGtuMrRrk9Gi-BS2UcyAUQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Dne 19.5.2014 09:13, M.H. Tsai napsal(a):
> Hi All,
>
> I'm using LVM2.2.02.106 and thin-provisioning-tools 0.3.2 on Ubuntu 13.10. I
> found that thin_repair doesn't do size checking on the output device, thus it
> will crash if the output device is larger than the space map's limitation
> (i.e., 255*16320*4096 bytes). The bitmap_count calculated by sm_disk::extend()
> might exceeded 255.
>
> The direct influence is that it cannot collaborate with the LVM2 "lvconvert
> --repair" command while the thinpool's metadata is exactly 16GiB. The reason
> is that the size of the pool metadata spare's DM target activated by
> _lvconvert_thinpool_repair() is 16384MiB, not 16192MiB. LVM2 only adjust the
> DM target's size to DM_THIN_MAX_METADATA_SIZE(16192MiB) while the metadata or
> the spare volume are activated within a thinpool.
>
> If this is a bug, I thought that it might be better to add size checking to
> thin_repair, since that users might use devices larger than 16GiB as the
> output device. Is that a feasible approach?


Yep - it's a bug and will need some fix.

Thanks for noticing this case.


Zdenek
