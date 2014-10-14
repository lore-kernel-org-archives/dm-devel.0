From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/4] md: add flush_idx support for stacked devices
Date: Tue, 14 Oct 2014 08:25:21 -0400
Message-ID: <20141014122520.GA7243@redhat.com>
References: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
 <1413281035-6483-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1413281035-6483-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 14 2014 at  6:03am -0400,
Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> For single device mapping it is safe to introduce get_flush_idx conception.
> This cover most common case linear mapping for a single dev.

You really should email the entire patchset rather than forcing the need
to hunt for the remainder of the patches that actually provide context
for this change.
