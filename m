From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: dm-cache performance behaviour
Date: Thu, 7 Apr 2016 00:41:25 +0900
Message-ID: <57052E25.5090503@gmail.com>
References: <20160405071253.GB27444@suselix.suse.de>
	<570378FC.3030701@redhat.com> <20160405140507.GG27444@suselix.suse.de>
	<20160405161226.GA17811@redhat.com> <20160406121349.GA11587@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160406121349.GA11587@kmo-pixel>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

If you don't mind out-of-tree kernel module,
there is dm-writeboost

https://github.com/akiradeveloper/dm-writeboost

it's both read/write caching and especially optimized for
write caching.
If you are using Ubuntu or Debian, it's available in
the packages.
Also, we have management tool that includes init script
so it's easy to start up.

Akira
