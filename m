From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 2/2] dm thin: Flush data device before
	committing metadata
Date: Wed, 4 Dec 2019 15:27:59 +0000
Message-ID: <20191204152759.qhh2f6ybhww7ivel@reti>
References: <20191204140742.26273-1-ntsironis@arrikto.com>
	<20191204140742.26273-3-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191204140742.26273-3-ntsironis@arrikto.com>
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
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 04, 2019 at 04:07:42PM +0200, Nikos Tsironis wrote:
> The thin provisioning target maintains per thin device mappings that map
> virtual blocks to data blocks in the data device.


Ack.  But I think we're issuing the FLUSH twice with your patch.  Since the
original bio is still remapped and issued at the end of process_deferred_bios?

- Joe
