From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [Question] How to make a patch?
Date: Sat, 10 Aug 2013 08:47:11 +0900
Message-ID: <52057F7F.7090406@gmail.com>
References: <52057742.4070101@gmail.com>
	<20130809232226.GA4493@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130809232226.GA4493@agk-dp.fab.redhat.com>
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

On 8/10/13 8:22 AM, Alasdair G Kergon wrote:
> At this stage, create a patch based against a released -rc kernel 
> from Linus.
> 
> If you use the linux-dm tree, then you can pick the tag v3.11-rc3,
> for example, which is the last time we updated.

Thanks for your response.

And I have a further question.

Do you mean
making a patch against rc4 in linux-next is not preferred?
I think if doing so,
the patch will be unable to apply to linux-dm
which I believe one going to be suggested to Linus.

I think I am going to make my patch against
v3.11-rc3 in linux-dm.
But, patching on kernel as fresh as possible
would make sense more.
