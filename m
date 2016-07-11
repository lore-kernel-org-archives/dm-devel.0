From: Matthias Dahl <ml_linux-kernel@binary-island.eu>
Subject: Re: [4.7.0rc6] Page Allocation Failures with dm-crypt
Date: Mon, 11 Jul 2016 10:31:22 +0200
Message-ID: <e7af885e08e1ced4f75313bfdfda166d@mail.ud19.udmedia.de>
References: <28dc911645dce0b5741c369dd7650099@mail.ud19.udmedia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <28dc911645dce0b5741c369dd7650099@mail.ud19.udmedia.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hello,

I made a few more tests and here my observations:

- kernels 4.4.8 and 4.5.5 show the same behavior

- the moment dd starts, memory usage spikes rapidly and within a just
   a few seconds has filled up all 32 GiB of RAM

- dd w/ direct i/o works just fine

- mkfs.ext4 unfortunately shows the same behavior as dd w/o direct i/o
   and such makes creation of an ext4 fs on dm-crypt a game of luck

   (much more exposed so with e2fsprogs 1.43.1)

I am kind of puzzled that this bug has seemingly gone so long unnoticed
since it is rather severe and makes dm-crypt unusable to a certain 
degree
for fs encryption (or at least the initial creation of the fs). Am I
missing something here or doing something terribly stupid?

With Kind Regards from Germany
Matthias

-- 
Dipl.-Inf. (FH) Matthias Dahl | Software Engineer | binary-island.eu
  services: custom software [desktop, mobile, web], server administration
