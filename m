From: "goggin, edward" <egoggin@emc.com>
Subject: bio/request merging
Date: Fri, 11 Feb 2005 10:10:11 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A78D@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

As written, blk_recount_segments() requires the size of physically
contiguous bio_vecs to not exceed the maximum virtually contiguous
region.  This seems to be done in order to optimize the calculation of
the hw_seg_size variable in the algorithm.  The code in
blk_phys_contig_segment() does not force this requirement for
physically contiguous regions?  Why the inconsistency?

Also, why do the initial back and front merges in __make_request()
done by ll_back_merge_fn() and ll_front_merge_fn() respectively only
consider virtually contiguous bio_vecs while the secondary merging
done in __make_request() by ll_merge_reqeusts_fn() considers both
physical and virtual bio_vec contiguity?

Off topic only a bit, but also important to bio_vec merging -- should not
an indication of the high physical page frame number, above which all
bio pages are bounced, be included in the device-mapper
io_restrictions structure used by blk_recount_segments() for all
I/O to a device-mapper mapped device?  Otherwise, isn't it possible for
blk_recount_segments() to include bio_vec pages in a physical
segment even if they may end up getting bounced if the bio is
sent, by say the multipath target driver, to a different target device
whose queue has a bounce_pfn value less than the one used by
blk_recount_segments() with the mapped device?



 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
