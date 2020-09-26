From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 2/2] multipath: Extend program description
	in manpage
Date: Sat, 26 Sep 2020 21:02:39 +0200
Message-ID: <bb1c3bce184dae7dc6148417aae115a87658a28c.camel@suse.com>
References: <AM0PR09MB289702395C44596866E4B9C3FE370@AM0PR09MB2897.eurprd09.prod.outlook.com>
	<AM0PR09MB2897B99544634CA56DA930D1FE370@AM0PR09MB2897.eurprd09.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AM0PR09MB2897B99544634CA56DA930D1FE370@AM0PR09MB2897.eurprd09.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Meinl <frank.meinl@live.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, 2020-09-26 at 18:29 +0200, Frank Meinl wrote:
> Add two paragraphs which list some advantages of multipath and
> explain
> the benefit for single path devices. The text has been partly
> composed
> by Benjamin Marzinski. - Refer to
> https://www.redhat.com/archives/dm-devel/2020-September/msg00431.html
> 
> Signed-off-by: Frank Meinl <frank.meinl@live.de>

Hm, this was not what I meant. multipath(8) is not the man page of the
dm-multipath kernel feature, it's the man page of the tool "multipath".
USB disks could just as well be set up using "multipathd". This text is
too generic and doesn't fit into multipath(8), neither generally nor
wrt style.

We don't have a man page about dm-multipath itself, and as nobody has
asked for it in 15 years, perhaps it's a bit late now to start one.

I know I asked you to do this, but thinking about it now, if you don't
mind, let's just leave it at the first patch.

Regards
Martin
