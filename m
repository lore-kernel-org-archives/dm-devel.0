From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [Bcache v13 00/16]
Date: Thu, 10 May 2012 11:03:53 -0400
Message-ID: <20120510150353.GI23768@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, tejun@google.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, May 09, 2012 at 11:07:29PM -0400, Kent Overstreet wrote:

[..]
> The userspace interface is going to change before it goes in. The general
> consensus at LSF was that we don't want yet another interface for
> probing/managing block devices, and dm exists so we may as well use that. I
> don't think anyone's started on that yet, though.
> 

Ok, I missed above lines and was pointed to it. So idea of this posting is
to review core changes and then somebody else needs to take the core, wrap
it with dm apis and repost?

Thanks
Vivek
