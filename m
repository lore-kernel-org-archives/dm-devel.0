From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: (unknown)
Date: Thu, 19 Jan 2012 15:00:17 +0200
Message-ID: <CALLzPKYdD22kg9QCtzLsENwTmBnkZqJ6sykrU1PoadTLMXtHTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Subject: 
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

Hi,

I rebased on the stop of latest mainline tree and now dmsetup fails...
It says: "Failed to create notification semaphore: Function not implemented".
I run strace and saw that dmsetup uses "semget" which returns -ENOSYS...

Any ideas?

- Dmitry
