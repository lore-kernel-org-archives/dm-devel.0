From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm table: add support for secure erase forwarding
 [was: Re: Adaptation secure erase forwarding for 4.1x kernels]
Date: Mon, 26 Mar 2018 12:11:32 -0400
Message-ID: <20180326161132.GA21310@redhat.com>
References: <1496940834.549721.1520933025411.JavaMail.zimbra@omprussia.ru>
	<20180322151045.GA27598@redhat.com>
	<695931032.318989.1521816469739.JavaMail.zimbra@omprussia.ru>
	<20180323153844.GA4914@redhat.com>
	<1943462632.77431.1522073575389.JavaMail.zimbra@omprussia.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1943462632.77431.1522073575389.JavaMail.zimbra@omprussia.ru>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Denis Semakin <d.semakin@omprussia.ru>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 26 2018 at 10:12am -0400,
Denis Semakin <d.semakin@omprussia.ru> wrote:

> Also, will it be usefully to add a "get...()" function for
> num_secure_erase_bios? Let's say get_num_secure_erase_bios(struct dm_target &ti);
> As it's done for num_discard_bios...

Yes, it is required.  I'll share a link to the final patch shortly, I've
still attributed the work to you.

BTW, please look into your text editor's settings: seems your patches
are using spaces rather than tabs (and you aren't even using 8 spaces?)

Mike
