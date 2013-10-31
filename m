From: Ed Cashin <ecashin@coraid.com>
Subject: Re: [PATCH 04/23] block: Abstract out bvec iterator
Date: Thu, 31 Oct 2013 13:14:48 -0400
Message-ID: <B60197FE-BC53-4EBA-8F78-02E4D9D31844@coraid.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
	<1383077896-4132-5-git-send-email-kmo@daterainc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1383077896-4132-5-git-send-email-kmo@daterainc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <kmo@daterainc.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>, Mike Snitzer <snitzer@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>, Joshua Morris <josh.h.morris@us.ibm.com>, hch@infradead.org, Geert Uytterhoeven <geert@linux-m68k.org>, Mel Gorman <mgorman@suse.de>, Nitin Gupta <ngupta@vflare.org>, Len Brown <len.brown@intel.com>, Sage Weil <sage@inktank.com>, Joern Engel <joern@logfs.org>, Rusty Russell <rusty@rustcorp.com.au>, Sunil Mushran <sunil.mushran@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Sadeh <yehuda@inktank.com>, Geoff Levand <geoff@infradead.org>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>Joe Perches <joe>
List-Id: dm-devel.ids

On Oct 29, 2013, at 4:17 PM, Kent Overstreet wrote:

> Immutable biovecs are going to require an explicit iterator. To
> implement immutable bvecs, a later patch is going to add a bi_bvec_done
> member to this struct; for now, this patch effectively just renames
> things.

Ack.  These patches pass sanity-check testing, too, for aoe.

-- 
  Ed Cashin
  ecashin@coraid.com
