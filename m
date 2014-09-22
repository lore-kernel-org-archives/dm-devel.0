From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Thinly-Provisioned Logical Volumes
Date: Mon, 22 Sep 2014 08:38:38 -0400
Message-ID: <20140922123837.GA5191@redhat.com>
References: <b3abf2cc-2219-4b5a-b546-5f71301c40e4@aliyun.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <b3abf2cc-2219-4b5a-b546-5f71301c40e4@aliyun.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lilofile <lilofile@aliyun.com>
Cc: Ondrej Kozina <okozina@redhat.com>, device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Sat, Sep 20 2014 at 10:19am -0400,
lilofile <lilofile@aliyun.com> wrote:

> when I test Thinly-Provisioned Logical Volumes(use device thinprovison
> target),I found the random write performance is very low. What factors
> will influence the random write performance of  thin volume.

It is worth reading this blog post from Joe:
http://device-mapper.org/blog/2014/01/21/random-io-and-copy-on-write-schemes/

> how can i quickly understand dm-bufio.c?

What is it you'd like to know?  dm-bufio.c isn't the smoking gun for
random write performance being slow though.  It is more to do with the
natural impact random writes have on thinp (as discussed in the above
article).
