From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: hradware_handler error on HP MSA1000
Date: Wed, 13 Aug 2008 10:45:52 -0400
Message-ID: <20080813144552.GA17006@mars.virtualiron.com>
References: <e368f40808130230q4160d6c5p5d263c8cf81352a9@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e368f40808130230q4160d6c5p5d263c8cf81352a9@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 13, 2008 at 11:30:58AM +0200, jean Diallo wrote:
> Hi
> I have been strugling with an HP MSA1000 for a few weeks now.
> I am using the old active/passive firmware.
> Here is the device section of my multipath.conf :

What made it neccessary to have an entry in multipath.conf? The built-in
values cover the settings for the old MSA1000.
