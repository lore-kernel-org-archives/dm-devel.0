From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] dm: add secdel target
Date: Thu, 18 Oct 2018 23:19:45 -0700
Message-ID: <20181019061945.GA7403@infradead.org>
References: <20181014112439.8119-1-vt@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181014112439.8119-1-vt@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Chikunov <vt@altlinux.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

Just as a note:  the name is a complete misowner, a couple overwrite
are not in any way secure deletion.  So naming it this way and exposing
this as erase is a problem that is going to get back to bite us.

If you really want this anyway at least give it a different way, and
do a one-time warning when th first erase comes in that it is not in
any meaninful way secure.
