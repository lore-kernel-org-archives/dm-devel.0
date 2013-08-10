From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [Question] How to make a patch?
Date: Sat, 10 Aug 2013 01:07:22 +0100
Message-ID: <20130810000722.GD4493@agk-dp.fab.redhat.com>
References: <52057742.4070101@gmail.com>
	<20130809232226.GA4493@agk-dp.fab.redhat.com>
	<52057F7F.7090406@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52057F7F.7090406@gmail.com>
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

On Sat, Aug 10, 2013 at 08:47:11AM +0900, Akira Hayakawa wrote:
> Do you mean
> making a patch against rc4 in linux-next is not preferred?

The risk of patching against linux-next directly is that you might find
yourself debugging problems in other subsystems when you try to test:)
But others would say that is that an advantage:)

It really shouldn't matter which point you choose at the moment because 
very little (nothing?) of relevance to your patch should be changing and
there will still be more revisions before the code is ready.

(For example, I think I saw someone point out that the interface needs a
careful review and might work better if done a different way.)

Alasdair
