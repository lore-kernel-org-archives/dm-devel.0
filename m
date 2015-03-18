From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCHv2] dm-verity: Add error handling modes for
 corrupted blocks
Date: Wed, 18 Mar 2015 13:26:31 +0000
Message-ID: <20150318132631.GB3176@google.com>
References: <20150316155559.GA32397@google.com>
	<20150317163707.GA39776@google.com>
	<20150317185053.GC21831@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150317185053.GC21831@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com, msb@chromium.org, wad@chromium.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 17, 2015 at 06:50:53PM +0000, Alasdair G Kergon wrote:
> The format needs to remain easily extendable.

Yes, I agree. I will address this in the next version.

> Or (my preference) use a 'features' approach like most other targets do:

This sounds like a better option to me, I will go with this.

Sami
