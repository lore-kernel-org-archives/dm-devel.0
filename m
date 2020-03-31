From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-zoned: add 'status' and 'message' callbacks
Date: Tue, 31 Mar 2020 10:45:52 -0400
Message-ID: <20200331144551.GA15485@redhat.com>
References: <20200327070849.67694-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200327070849.67694-1-hare@suse.de>
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
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 27 2020 at  3:08am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> Add callbacks to supply information for 'dmsetup status'
> and 'dmsetup info', and implement the message 'reclaim'
> to start the reclaim worker.

Who/What will use the 'reclaim' message?  Shouldn't it be documented?
Think the dmz_status changes should be split out from this reclaim
message.

BTW, these dm-zoned changes (and your following 4 patch set) missed 5.7
-- merge window opened Sunday.

Mike
