From: bart.coninckx@telenet.be
Subject: Re: understanding of multipathing and speed
Date: Tue, 6 Jul 2010 10:52:22 +0200 (CEST)
Message-ID: <1119755453.300181278406342201.JavaMail.root@tendai.telenet-ops.be>
References: <1278404700.26874.5.camel@Nokia-N900-42-11>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_15452_1193671994.1278406342197"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1278404700.26874.5.camel@Nokia-N900-42-11>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

------=_Part_15452_1193671994.1278406342197
Content-Type: multipart/alternative;
	boundary="----=_Part_15453_252972884.1278406342197"

------=_Part_15453_252972884.1278406342197
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


----- Originele e-mail ----- 
Van: "Christophe Varoqui" <christophe.varoqui@gmail.com> 
Aan: "bart coninckx" <bart.coninckx@telenet.be> 
Cc: dm-devel@redhat.com 
Verzonden: Dinsdag 6 juli 2010 10:25:00 GMT +01:00 Amsterdam / Berlijn / Bern / Rome / Stockholm / Wenen 
Onderwerp: Re: [dm-devel] understanding of multipathing and speed 



> routing points to the correct interface per network. Maybe my test 
> (bonnie++) 
> 
> is not an appropriate one to show the difference in speed? 
> 
an interesting data point would be a perf run when iet target has only one target port on a bonded interface a multipath on client side. 

And maybe the other combinations. Th eset combinations would be : 
- client bonded, target not bonded 
- client bonded, target bonded (i understand this is the scenario with good performance you reported earlier) 
- client not bonded, target not bonded (perf expected from a single path in your testing) 
- client not bonded, target bonded 

the mixed setup would not be adequate for production as they require linked or single switch setups, but the information might help determine if the performance drop is due to multipath or iet multi-target. 

Bye. 
-- dm-devel mailing list dm-devel@redhat.com https://www.redhat.com/mailman/listinfo/dm-devel 

Christophe, 

I have previously done no bonding in this setup, that was just to refer to how I would multipathing would behave speed wise when configured with round-robin, namely just like bonding does with round robin: the speed is almost doupled. 

This is now a production machine, so juggling with bonding and non-bonding is somewhat difficult. I did do a tcpdump on both interfaces while doing a copy and there seems to be traffic on both interfaces while I copy a file, but the speed does not prove to get higher with interfaces available. 

Would it matter if I experiment with rr-min-io? This is now set to 100. 

Cheers, 


Bart 

------=_Part_15453_252972884.1278406342197
Content-Type: multipart/related;
	boundary="----=_Part_15454_1845123975.1278406342197"

------=_Part_15454_1845123975.1278406342197
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html><head><style type='text/css'>p { margin: 0; }</style></head><body><div style='font-family: Arial; font-size: 10pt; color: #000000'><br>----- Originele e-mail  -----<br>Van: "Christophe Varoqui" &lt;christophe.varoqui@gmail.com&gt;<br>Aan: "bart coninckx" &lt;bart.coninckx@telenet.be&gt;<br>Cc: dm-devel@redhat.com<br>Verzonden: Dinsdag 6 juli 2010 10:25:00 GMT +01:00 Amsterdam / Berlijn / Bern / Rome / Stockholm / Wenen<br>Onderwerp: Re: [dm-devel] understanding of multipathing and speed<br><br>

    
    
    <title></title>
<p>&gt; routing points to the correct interface per network. Maybe my test
<br>&gt; (bonnie++) 
<br>&gt; 
<br>&gt; is not an appropriate one to show the difference in speed? 
<br>&gt; 
<br>an interesting data point would be a perf run when iet target has only one target port on a bonded interface a multipath on client side.
<br>
<br>And maybe the other combinations. Th eset combinations would be :
<br>- client bonded, target not bonded
<br>- client bonded, target bonded (i understand this is the scenario with good performance you reported earlier)
<br>- client not bonded, target not bonded (perf expected from a single path in your testing)
<br>- client not bonded, target bonded
<br>
<br>the mixed setup would not be adequate for production as they require linked or single switch setups, but the information might help determine if the performance drop is due to multipath or iet multi-target.
<br>
<br>Bye.</p>
<br>--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel<br><br>Christophe,<br><br>I have previously done no bonding in this setup, that was just to refer to how I would multipathing would behave speed wise when configured with round-robin, namely just like bonding does with round robin: the speed is almost doupled. <br><br>This is now a production machine, so juggling with bonding and non-bonding is somewhat difficult.&nbsp; I did do a tcpdump on both interfaces while doing a copy and there seems to be traffic on both interfaces while I copy a file, but the speed does not prove to get higher with interfaces available. <br><br>Would it matter if I experiment with rr-min-io? This is now set to 100.<br><br>Cheers,<br><br><br>Bart<br></div></body></html>
------=_Part_15454_1845123975.1278406342197
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment
Content-ID: <1278404698.26874.2.camel@Nokia-N900-42-11>

> routing points to the correct interface per network. Maybe my test
> (bonnie++) 
> 
> is not an appropriate one to show the difference in speed? 
> 
an interesting data point would be a perf run when iet target has only one target port on a bonded interface a multipath on client side.

And maybe the other combinations. Th eset combinations would be :
- client bonded, target not bonded
- client bonded, target bonded (i understand this is the scenario with good performance you reported earlier)
- client not bonded, target not bonded (perf expected from a single path in your testing)
- client not bonded, target bonded

the mixed setup would not be adequate for production as they require linked or single switch setups, but the information might help determine if the performance drop is due to multipath or iet multi-target.

Bye.
------=_Part_15454_1845123975.1278406342197--

------=_Part_15453_252972884.1278406342197--

------=_Part_15452_1193671994.1278406342197
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_Part_15452_1193671994.1278406342197--
