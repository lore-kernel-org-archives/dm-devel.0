From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard
 failure? [was: Re: dm snapshot: ignore discards issued to the
 snapshot-origin target]
Date: Fri, 29 Apr 2011 08:29:06 -0400
Message-ID: <20110429122906.GA7381@infradead.org>
References: <20110412234706.GA11244@redhat.com>
 <20cf301cbef67d323104a0c2ff52@google.com>
 <20110413224025.GA18589@redhat.com>
 <20110413234854.GA19793@redhat.com>
 <20110426173213.GA19604@redhat.com>
 <20110428001912.GA14659@redhat.com>
 <20110428075355.GA2190@infradead.org>
 <20110428205935.GA24979@redhat.com>
 <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com>
 <20110429122454.GL32370@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110429122454.GL32370@agk-dp.fab.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>, Mike Snitzer <snitzer@redhat.com>, sandeen@redhat.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, DarkNovaNick@gmail.com, linux-l
List-Id: dm-devel.ids

FYI, that disable discard on failure seems to be an ext4 special and no
one else picked up that stupid idea.  If ext4 wants to misbehave for
that just let them..

