From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [Lsf-pc] Bcache
Date: Wed, 14 Mar 2012 15:09:12 -0700
Message-ID: <CABE8wwvtH818aP18r0XgGgiCCFLOKJXCzHdysQeAGC93SETPBw@mail.gmail.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
	<20120314155339.GC30235@redhat.com>
	<CAH+dOxKxZYSdZfewt5mHsvOk68VfNKzMQveibGLM+qunV6mOMw@mail.gmail.com>
	<20120314220150.GA15464@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20120314220150.GA15464@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, nauman@google.com, lsf-pc@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Wed, Mar 14, 2012 at 3:01 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> I'm very early in the design but hope to have an initial functional
> version of the code together in time for LSF -- ~2 weeks may be too
> ambitious but it's my goal (could be more doable if I confine the
> initial code to writethrough with LRU).

I'm hoping caching ends up being as successful as the raid456
unification where we can have a dm or md interface in front of some
common infrastructure.  The inertia for md is to keep it close to all
the recent software raid advancements, the inertia for dm is also
clear, the inertia for something brand new... not very clear.

--
Dan
