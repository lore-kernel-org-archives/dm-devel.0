From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH v2 01/13] dm-mpath: Split activate_path()
Date: Fri, 28 Apr 2017 07:59:16 +0200
Message-ID: <222075d5-f7a6-d1fa-a3f5-1e2b63f7e63f@suse.de>
References: <20170427171126.26814-1-bart.vanassche@sandisk.com>
 <20170427171126.26814-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170427171126.26814-2-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On 04/27/2017 07:11 PM, Bart Van Assche wrote:
> This patch does not change any functionality but makes the next
> patch in this series easier to read.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/md/dm-mpath.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
