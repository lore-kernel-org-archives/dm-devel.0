From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: dm-crypt hard lockup
Date: Tue, 30 Jun 2020 10:05:43 +0200
Message-ID: <9fa466c0-d99e-338d-c93c-68aac372217c@intel.com>
References: <fb4877be-4d88-2816-9000-dcc540e8c093@intel.com>
	<f4e57ef4-e0df-d2e6-a00a-074a08f10dbb@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f4e57ef4-e0df-d2e6-a00a-074a08f10dbb@acm.org>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 6/28/20 6:50 PM, Bart Van Assche wrote:
> Since considerable time I'm doing kernel builds (make -j8) on an
> openSUSE Tumbleweed system on top of dm-crypt and an NVMe SSD but I have
> not yet encountered any kind of lockup. Maybe another driver, e.g. an
> I/O scheduler, is responsible for the lockups?

It could by another driver. I tried with a different filesystem (xfs),
without any I/O scheduler and even with the sources on a different drive
without dm-crypt, and the results were more or less the same - lockups
involving dm-crypt. Maybe I'm just abusing the system - I'm actually
running "make -j", so the number of tasks is unlimited. With a limited
number it does not hang. I know it's not a good idea to do this but it
used to work, and I think it shouldn't cause the kernel to die like
this.

Artur
