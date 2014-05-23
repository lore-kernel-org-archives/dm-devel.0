From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: dm-writeboost: Progress Report
Date: Fri, 23 May 2014 22:14:42 +0900
Message-ID: <537F49C2.3000304@gmail.com>
References: <537775B0.2060907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <537775B0.2060907@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, masami.hiramatsu@gmail.com, devel@etsukata.com
List-Id: dm-devel.ids

Hi Guys,

This progress report includes very important benchmarking results, which shows
i) Write will always improve - It boosts writes (396% in the best case) even with really small cache (say, 64MB) because of the sophisticated writeback optimization.
ii) Read won't be bad - It doesn't so much deteriorate the read (less than 1% for SSD+HDD case) because of the insignificant overhead.
iii) Good in application workloads - 22% improvement with read-intensive workload and 234-299% improvement with fileserver workload (using dbench)

Yeah, merging Writeboost into the mainline is my goal now and I really need your feedbacks.
For more details, please read the previous post.

Cheers,
- Akira
