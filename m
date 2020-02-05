From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] dm,dax: Add dax zero_page_range operation
Date: Wed, 5 Feb 2020 10:33:04 -0800
Message-ID: <20200205183304.GC26711@infradead.org>
References: <20200203200029.4592-1-vgoyal@redhat.com>
 <20200203200029.4592-4-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200203200029.4592-4-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 03, 2020 at 03:00:27PM -0500, Vivek Goyal wrote:
> This patch adds support for dax zero_page_range operation to dm targets.

Any way to share the code with the dax copy iter here?
