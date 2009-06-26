From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that
 checks data integrity
Date: Fri, 26 Jun 2009 23:53:57 +0100
Message-ID: <20090626235357.7bec63a8@lxorguk.ukuu.org.uk>
References: <20090521161317.GU1376@blitiri.com.ar>
	<87my91qsn4.fsf@frosties.localdomain>
	<20090525174630.GI1376@blitiri.com.ar>
	<8763fop31e.fsf@frosties.localdomain>
	<20090526125252.GL1376@blitiri.com.ar>
	<878wkhyqj3.fsf@frosties.localdomain>
	<37d33d830906260026t60ae1c71h981b6f3bc0165053@mail.gmail.com>
	<20090626223634.GG5913@blitiri.com.ar>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090626223634.GG5913@blitiri.com.ar>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-kernel@vger.kernel.org, SandeepKsinha <sandeepksinha@gmail.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

> If it returns success but writes the wrong data to the disk, then there will
> be a mismatch between the checksum and the data at the destination, which will
> be detected when it is read.

(or to the wrong place on the disk which for pre SATA is actually
possibly more likely as the command transfers are not CRC protected on
the cable - just slower, while the data is CRC protected). SATA fixes
this.

> If a write returns success but no write ever takes place on the disk, then
> dm-csum (as it is now) will not detect it; although I'm not sure if that
> qualifies as on-disk data corruption or is it a disk controller issue.

Does it matter to the poor victim ? At this point you get into putting
mirrors on disks A & B with their integrity on the opposite pair so if
one forgets to do I/O hopefully both won't.

To be honest if you are really really paranoid you don't do link layer
checksumming anyway (which is what this is) you checksum in the apps using
the data set. That protects you against lots of error cases in the
memory/cache system and on network transmissions. On big clusters
crunching enormous amounts of data all those 1 in 10^lots bit error rates
become such that it's worth the effort.

> It's per IMD sector. More specifically, struct imd_sector_header's
> last_updated contains the generation count for the entire IMD sector, which is
> used to determine which one is younger for updating purposes.
> 
> On reads, both IMD sectors are loaded and CRCs are verified against both.

Seems reasonably paranoid - drives will do things under you like commit
data to disk out in a different order to the commands unless the cache
gets flushed between them but the barrier code should do that bit.

Alan
