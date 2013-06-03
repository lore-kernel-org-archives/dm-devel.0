From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [Fwd: Re: DM-Verity Tool]
Date: Mon, 3 Jun 2013 10:29:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1306031027440.8171@file.rdu.redhat.com>
References: <62980.192.168.200.1.1370006888.squirrel@gesmail.globaledgesoft.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <62980.192.168.200.1.1370006888.squirrel@gesmail.globaledgesoft.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: pavankumar.p@globaledgesoft.com
Cc: device-mapper development <dm-devel@redhat.com>, Marian Csontos <mcsontos@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids



On Fri, 31 May 2013, pavankumar.p@globaledgesoft.com wrote:

> ---------------------------- Original Message ----------------------------
> Subject: Re: DM-Verity Tool
> From:    pavankumar.p@globaledgesoft.com
> Date:    Mon, May 27, 2013 9:22 pm
> To:      "Milan Broz" <gmazyland@gmail.com>
>          mpatocka@redhat.com
>          "device-mapper development" <dm-devel@redhat.com>
>          "Marian Csontos" <mcsontos@redhat.com>
> --------------------------------------------------------------------------
> 
> Hello Mikulas,
> 
> > By corrupting the image? :) See tests/verity-compat-test in cryptsetup
> > tree, it is basic regression test which is simulating both data and hash
> > corruption (it just dd random data to know offset and expects failure.)
> 
> In tests/verity-compat-test, in the following line
> "check_root_hash  512
> 9de18652fe74edfb9b805aaed72ae2aa48f94333f1ba5c452ac33b1c39325174 $SALT 1
> sha256 8388608"
> 
> How's the last parameter (hash_offset) calculated? it's hard coded
> here(8388608).
> 
> Regards,
> Pavan

If you use two separate devices for data and hash, hash offset is zero 
(hash starts at the beginning of the second device).

If you use one block device for both data and hash, hash offset points to 
the end of the data (and beginning of hash) - if you want to use it this 
way, you have to set hash offset manually.

Mikulas
