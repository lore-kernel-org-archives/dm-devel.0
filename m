From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: Bug? Determining the holders of partitions shadowed
	by dm-multipath.
Date: Wed, 11 Feb 2009 00:03:34 -0800
Message-ID: <20090211080334.GH9512@mail.oracle.com>
References: <20090210004951.GA4341@mail.oracle.com>
	<16F7C86087BE0247B20562A9E6B07DC75BB5DAA6@excnysm95bagp.nysemail.nyenet>
	<20090210213239.GA30270@mail.oracle.com> <49927F04.3070404@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49927F04.3070404@suse.de>
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

On Wed, Feb 11, 2009 at 08:32:20AM +0100, Hannes Reinecke wrote:
> Hi Joel,
>
> Joel Becker wrote:
>> On Tue, Feb 10, 2009 at 09:49:58AM -0500, Romanowski, John (OFT) wrote:
>>> my sles10sp2 at 2.6.16.60-0.29-default doesn't have the /sys/block/.../holders but
>>> I've used major:minor device numbers from commands
>>> dmsetup ls
>>> and
>>> dmsetup deps
>>> to resolve such device relationships.
>>>
>>> A 'dmsetup ls' device number that isn't listed in 'dmsetup deps' device numbers is a top-level device. Example below: mproot-part1 (dev 253:3, a partition of mp device 253:2) isn't listed as a dependency of any device. Likewise each listed LVM volume isn't listed as a dependency of any device; example- rootvg-tmp 253:10
>>
>> 	Sure, but a /dev/sda2 won't show up in dmsetup output anywhere.
>> That's kind of my point.
>>
> Well, yes.
> That's because you have _two_ parent-child relationship in sysfs.
>
> The one (as you already noted) is the holders / slaves directories in sysfs.
> However, partitions are handled differently; they are listed under
>
> /sys/block/sda/sda2
>
> (note the subdir) and do not appear under holders / slaves. So the correct algorithm
> is to
> a) check the holders / slaves
> and
> b) check if the parent directory starts with the same name and if so, check for
> the holders / slaves relationship there.

	Why not just setup holders in sda2?  It's held, after all.
It's just very counterintuitive to look at an empty holders and discover
that it's empty yet held.
	Btw, do we absolutely guarantee that all block devices, forever,
will have partitions in sysfs named
"/sys/block/<parent>/<parent><more>"?

Joel

-- 

Life's Little Instruction Book #139

	"Never deprive someone of hope; it might be all they have."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
