From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard failure?
 [was: Re: dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Fri, 29 Apr 2011 09:28:51 -0500
Message-ID: <4DBACB23.80607@redhat.com>
References: <20110412234706.GA11244@redhat.com> <20cf301cbef67d323104a0c2ff52@google.com> <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com> <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com> <20110429122454.GL32370@agk-dp.fab.redhat.com> <20110429122906.GA7381@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20110429122906.GA7381@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Lukas Czerner <lczerner@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, DarkNovaNick@gmail.com, linux-lvm@redhat.com, linux-ext4@vger.kernel.org
List-Id: dm-devel.ids

On 4/29/11 7:29 AM, Christoph Hellwig wrote:
> FYI, that disable discard on failure seems to be an ext4 special and no
> one else picked up that stupid idea.  If ext4 wants to misbehave for
> that just let them..

It was my "stupid idea," and I'm ok with reverting it ;)

-Eric
