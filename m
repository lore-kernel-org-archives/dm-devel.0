From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/5] dm,dax: Add dax zero_page_range operation
Date: Fri, 7 Feb 2020 11:34:01 -0500
Message-ID: <20200207163401.GB11998@redhat.com>
References: <20200203200029.4592-1-vgoyal@redhat.com>
 <20200203200029.4592-4-vgoyal@redhat.com>
 <20200205183304.GC26711@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200205183304.GC26711@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 05, 2020 at 10:33:04AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 03, 2020 at 03:00:27PM -0500, Vivek Goyal wrote:
> > This patch adds support for dax zero_page_range operation to dm targets.
> 
> Any way to share the code with the dax copy iter here?

Had a look at it and can't think of a good way of sharing the code. If
you have something specific in mind, I am happy to make changes.

Vivek
