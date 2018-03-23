From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm table: add support for secure erase forwarding
 [was: Re: Adaptation secure erase forwarding for 4.1x kernels]
Date: Fri, 23 Mar 2018 11:38:44 -0400
Message-ID: <20180323153844.GA4914@redhat.com>
References: <1496940834.549721.1520933025411.JavaMail.zimbra@omprussia.ru>
	<20180322151045.GA27598@redhat.com>
	<695931032.318989.1521816469739.JavaMail.zimbra@omprussia.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <695931032.318989.1521816469739.JavaMail.zimbra@omprussia.ru>
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

On Fri, Mar 23 2018 at 10:47am -0400,
Denis Semakin <d.semakin@omprussia.ru> wrote:

> >I'd feel safer about having targets opt-in with setting (a new)
> >ti->num_secure_erase_bios.
> May be add a new field "bool secure_erase_supported:1" in dm_target structure instead?
> And set up it "true" in constructor for linear targets.

No, that type of change is for a DM target to support a feature even if
the underlying device doesn't.

As my previous email elaborated, ti->num_secure_erase_bios is the right
way forward.

Mike
