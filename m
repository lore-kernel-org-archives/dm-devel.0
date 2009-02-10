From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: Bug? Determining the holders of partitions shadowed
	by dm-multipath.
Date: Tue, 10 Feb 2009 13:32:39 -0800
Message-ID: <20090210213239.GA30270@mail.oracle.com>
References: <20090210004951.GA4341@mail.oracle.com>
	<16F7C86087BE0247B20562A9E6B07DC75BB5DAA6@excnysm95bagp.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <16F7C86087BE0247B20562A9E6B07DC75BB5DAA6@excnysm95bagp.nysemail.nyenet>
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

On Tue, Feb 10, 2009 at 09:49:58AM -0500, Romanowski, John (OFT) wrote:
> my sles10sp2 at 2.6.16.60-0.29-default doesn't have the /sys/block/.../holders but
> I've used major:minor device numbers from commands
> dmsetup ls
> and
> dmsetup deps
> to resolve such device relationships.
> 
> A 'dmsetup ls' device number that isn't listed in 'dmsetup deps' device numbers is a top-level device. Example below: mproot-part1 (dev 253:3, a partition of mp device 253:2) isn't listed as a dependency of any device. Likewise each listed LVM volume isn't listed as a dependency of any device; example- rootvg-tmp 253:10

	Sure, but a /dev/sda2 won't show up in dmsetup output anywhere.
That's kind of my point.

Joel

-- 

Life's Little Instruction Book #198

	"Feed a stranger's expired parking meter."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
