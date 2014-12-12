From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [dm-devel] [PATCH v2] staging: writeboost: Add dm-writeboost
Date: Fri, 12 Dec 2014 18:35:32 +0900
Message-ID: <548AB6E4.2020302@gmail.com>
References: <54883195.1060304@gmail.com> <20141211152626.GA8196@redhat.com>
 <548A39E7.80508@gmail.com> <548AB172.4000103@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <548AB172.4000103@acm.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: bvanassche@acm.org
Cc: thornber@redhat.com, snitzer@redhat.com, gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 12/12/14 6:12 PM, Bart Van Assche wrote:
> This is the first time I see someone claiming that reducing the request size improves performance. I don't know any SSD model for which splitting requests improves performance.

Writeboost batches number of writes into a log (that is 512KB large) and submits to SSD
which maximizes the throughput and the lifetime of the SSD.
I think you fairly misunderstand how Writeboost works.

- Akira
