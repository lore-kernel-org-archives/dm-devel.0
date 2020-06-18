From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [dm-devel] New mode DM-Verity error handling
Date: Thu, 18 Jun 2020 09:50:06 -0700
Message-ID: <20200618165006.GA103290@google.com>
References: <CGME20200618070250epcas1p409eb2ddd19ecc5d55c219ac3dc884f25@epcas1p4.samsung.com>
 <98eac3fc-c399-625d-5730-29853b3a0771@samsung.com>
 <20200618154444.GB18007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200618154444.GB18007@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: JeongHyeon Lee <jhs2.lee@samsung.com>, dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com, corbet@lwn.net
List-Id: dm-devel.ids

On Thu, Jun 18, 2020 at 11:44:45AM -0400, Mike Snitzer wrote:
> I do not accept that panicing the system because of verity failure is
> reasonable.
> 
> In fact, even rebooting (via DM_VERITY_MODE_RESTART) looks very wrong.
> 
> The device should be put in a failed state and left for admin recovery.

That's exactly how the restart mode works on some Android devices. The
bootloader sees the verification error and puts the device in recovery
mode. Using the restart mode on systems without firmware support won't
make sense, obviously.

Sami
