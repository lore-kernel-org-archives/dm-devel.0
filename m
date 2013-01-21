From: Alan Cox <alan.cox@intel.com>
Subject: Re: dm-integrity: integrity protection device-mapper target
Date: Mon, 21 Jan 2013 13:51:57 +0000
Message-ID: <20130121135157.47a68a57@bob.linux.org.uk>
References: <Pine.LNX.4.64.1301151955280.7468@file.rdu.redhat.com>
	<CALLzPKZVo3ng=Hz4cg0qrw0nDYsPjKy5AR=AJtMg+3PU=epz1w@mail.gmail.com>
	<20130118231633.GM27585@agk-dp.fab.redhat.com>
	<CALLzPKZS6WgBxPcXJ1Eoe09QD_-T98E4x29qUo-fNAAt1ajTrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALLzPKZS6WgBxPcXJ1Eoe09QD_-T98E4x29qUo-fNAAt1ajTrw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

> This is not to provide reliability.
> Default is to return error. But zero might be desirable. 

There are cases where being able to force blocks to all zeros is itself
a security attack and it seems an odd behaviour. Error on read/allow
write seems sensible enough.

---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

