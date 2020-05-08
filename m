From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 14/14] dm-zoned: metadata version 2
Date: Fri, 8 May 2020 12:38:44 -0400
Message-ID: <20200508163844.GB18662@redhat.com>
References: <20200508090332.40716-1-hare@suse.de>
	<20200508090332.40716-15-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200508090332.40716-15-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Hannes Reinecke <hare@suse.de>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, May 08 2020 at  5:03am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> Implement handling for metadata version 2. The new metadata adds
> a label and UUID for the device mapper device, and additional UUID
> for the underlying block devices.
> It also allows for an additional regular drive to be used for
> emulating random access zones. The emulated zones will be placed
> logically in front of the zones from the zoned block device, causing
> the superblocks and metadata to be stored on that device.
> The first zone of the original zoned device will be used to hold
> another, tertiary copy of the metadata; this copy carries a
> generation number of 0 and is never updated; it's just used
> for identification.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bob Liu <bob.liu@oracle.com>

Noticing some changes layered ontop of what I expected (your previous
version + Damien's changes [1] folded in).

The changelog on the 0th header doesn't really speak to the changes I'm
seeing.  Is it worth enumerating them to ease incremental review?
Damien?

[1] https://www.redhat.com/archives/dm-devel/2020-April/msg00273.html

Thanks,
Mike
