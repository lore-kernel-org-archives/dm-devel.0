From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm thin: relax hard limit on the maximum
 size of a metadata device
Date: Mon, 5 Mar 2012 10:21:34 +0000
Message-ID: <20120305102133.GB6431@ubuntu>
References: <1330723953-16872-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1330723953-16872-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

Hi Mike,

My concerns are:

i) The current behaviour is upstream; by changing this aren't you
   making the tools writers life more complicated rather than less by
   making them support both interfaces?

ii) 16G is a ludicrous amount of space to allocate for metadata (16M
    would be much better).  Why are the tools trying to allocate this
    much?  LVM2's unit of _allocation_ may be the extent, but this is
    separate from activation.  If your extent size is 16G you can
    probably squeeze 1000 metadata areas into there.

    As a side issue it's not clear to me why anyone would want to use
    16G extents?  (eg, 16M extents lets them address 2^56 bytes of
    data in the VG).  Maybe the sys admins mistakenly think they're
    getting performance benefits through having more contiguous data?
    [LVM2's allocation policies try and allocate contiguous extents
    anyway].

If you can reassure me about (i) and that your patch isn't encouraging
poor tool code (ii), then I'll ack this patch.

- Joe


On Fri, Mar 02, 2012 at 04:32:33PM -0500, Mike Snitzer wrote:
> The thin metadata format can only make use of a device that is <=
> METADATA_DEV_MAX_SECTORS (currently 15.9375 GB).  Therefore, there is no
> practical benefit to using a larger device.
> 
> However, it may be that other factors impose a certain granularity for
> the space that is allocated to a device (E.g. lvm2 can impose a coarse
> granularity through the use of large, >= 1 GB, physical extents).
> 
> Rather than reject a larger metadata device, during thin-pool device
> construction, switch to allowing it but issue a warning if a device
> larger than METADATA_DEV_MAX_SECTORS_NEAREST_POWER_OF_2 (16 GB) is
> provided.  Any space over 15.9375 GB will not be used.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
