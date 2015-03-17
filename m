From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm-verity: Add error handling modes for
 corrupted blocks
Date: Tue, 17 Mar 2015 10:35:22 +0000
Message-ID: <20150317103522.GA40896@google.com>
References: <20150316155559.GA32397@google.com>
	<CABqD9hak_3uhczdpj70WDH9A2FfgT69zdvV8+xDH8omFEhPvSA@mail.gmail.com>
	<20150317004555.GB21831@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150317004555.GB21831@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Will Drewry <wad@chromium.org>, Mandeep Baines <msb@chromium.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 17, 2015 at 12:45:55AM +0000, Alasdair G Kergon wrote:
> 'table' should show the new parameter and 'status' should probably show
> it too if it's needed to interpret the 'status' properly.

Good point, I will add it to 'table' in v2. I doubt it's necessary in 'status'
though, userspace should be able to decide how to handle errors without it.

Sami
