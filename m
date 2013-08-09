From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [Question] How to make a patch?
Date: Sat, 10 Aug 2013 00:22:26 +0100
Message-ID: <20130809232226.GA4493@agk-dp.fab.redhat.com>
References: <52057742.4070101@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52057742.4070101@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Aug 10, 2013 at 08:12:02AM +0900, Akira Hayakawa wrote:
> linux-dm seems to have a tag dm-3.11-changes.
> Should I make patch on this point?
 
At this stage, create a patch based against a released -rc kernel 
from Linus.

If you use the linux-dm tree, then you can pick the tag v3.11-rc3,
for example, which is the last time we updated.

Alasdair
