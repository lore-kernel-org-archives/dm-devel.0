From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH v2 1/1] dm-raid45
Date: Wed, 9 Dec 2009 05:43:09 -0500
Message-ID: <20091209104309.GA8262@infradead.org>
References: <1259243112-28175-1-git-send-email-heinzm@redhat.com> <e9c3a7c20912081638w39469743n76b4114b840f1c43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c20912081638w39469743n76b4114b840f1c43@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

On Tue, Dec 08, 2009 at 05:38:06PM -0700, Dan Williams wrote:
> Where did the investigation of reusing md/raid5.c [1] end up?  This
> would simultaneously enable hardware accelerated raid6 for dmraid.

Yes, adding different raid code to dm is a bad idea, even more so after
Neil showed a useful prototype of reusing the md code.

