From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC] dm-bow working prototype
Date: Tue, 23 Oct 2018 23:18:19 +0100
Message-ID: <20181023221819.GB17552@agk-dp.fab.redhat.com>
References: <20181023212358.60292-1-paullawrence@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181023212358.60292-1-paullawrence@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Lawrence <paullawrence@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Oct 23, 2018 at 02:23:28PM -0700, Paul Lawrence wrote:
> It is planned to use this driver to enable restoration of a failed
> update attempt on Android devices using ext4.

Could you say a bit more about the reason for this new dm target so we
can understand better what parameters you are trying to optimise and
within what new constraints?  What are the failure modes that you need
to handle better by using this?  (We can guess some answers, but it
would better if you can lay them out so we don't need to make
assumptions.)

Alasdair
