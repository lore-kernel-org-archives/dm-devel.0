From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH v2 1/1] dm-raid45
Date: Wed, 09 Dec 2009 18:43:26 +0100
Message-ID: <1260380606.9639.95.camel@o>
References: <1259243112-28175-1-git-send-email-heinzm@redhat.com>
	<e9c3a7c20912081638w39469743n76b4114b840f1c43@mail.gmail.com>
	<20091209104309.GA8262@infradead.org>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091209104309.GA8262@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


Please don't forget the point about 3rd party tests of the xor
optimization in dm-reaid45 vs. the crypto one. I want that to be tested
in order to prove, if we got an advantage over the crypto implementation
or not.

Heinz

On Wed, 2009-12-09 at 05:43 -0500, Christoph Hellwig wrote:
> On Tue, Dec 08, 2009 at 05:38:06PM -0700, Dan Williams wrote:
> > Where did the investigation of reusing md/raid5.c [1] end up?  This
> > would simultaneously enable hardware accelerated raid6 for dmraid.
> 
> Yes, adding different raid code to dm is a bad idea, even more so after
> Neil showed a useful prototype of reusing the md code.
> 
