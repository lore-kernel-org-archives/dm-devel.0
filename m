From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: multipathing Sun 6140
Date: Fri, 13 Jun 2008 10:27:12 -0400
Message-ID: <20080613142712.GB27204@mars.virtualiron.com>
References: <484705D1.6080200@provectis.cl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <484705D1.6080200@provectis.cl>
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
Cc: julio.pacheco@provectis.cl
List-Id: dm-devel.ids

On Wed, Jun 04, 2008 at 05:14:57PM -0400, Gustavo Riveros wrote:
> Hi dm-developers,
>
> I'm having problem with multipathing device-mapper with my linux server, 
> but this was resolved by Thread "multipathing flip flopping on Sun 6140" 
> very well 
> (http://www.redhat.com/archives/dm-devel/2007-August/msg00066.html)

That multipath.conf entry seems to be missing some key elements:

     device {
                vendor                  "SUN"
                product                 "CSM200_R"
                product_blacklist       "Universal Xport"
                features                "1 queue_if_no_path"
                path_checker    rdac
                hardware_handler        "1 rdac"
                path_grouping_policy    group_by_prio
                prio                    "rdac"
                failback                immediate
        }

>
> The configuration is the same:
>
> X4600 Server
> 2 HBA's Emulex
> SAN STK6140
>
> but in dmesg i have the following error message:
>
> Buffer I/0 error on device sdf, logical block 0
> end_request: I/0 error, dev sdf, sector 0
>
> Did you know the error message?

That would imply you are using the 'readsector0' checker program
instead of the 'rdac' one.

The multipath.conf above assumes that this controller is indeed an RDAC
one. I don't have one so the configuration might be completly wrong.
