From: "Sandeep Kumar" <sandeepksinha@gmail.com>
Subject: Re: doubt about linear_ctr
Date: Fri, 24 Nov 2006 13:03:40 +0530
Message-ID: <37d33d830611232333ue727ac1n83fc928aec072db2@mail.gmail.com>
References: <37d33d830611232326i1aefbfa6v86aa97ec6696792@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_Part_41703_25562570.1164353620337"
Return-path: <kernelnewbies-bounce@nl.linux.org>
In-Reply-To: <37d33d830611232326i1aefbfa6v86aa97ec6696792@mail.gmail.com>
Sender: kernelnewbies-bounce@nl.linux.org
Errors-to: kernelnewbies-bounce@nl.linux.org
List-help: <mailto:ecartis@nl.linux.org?Subject=help>
List-unsubscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=unsubscribe>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=subscribe>
List-owner: <mailto:ecartis-owner@nl.linux.org>
List-post: <mailto:kernelnewbies@nl.linux.org>
List-archive: <http://mail.nl.linux.org/kernelnewbies/>
To: dm-devel@redhat.com, kernelnewbies <kernelnewbies@nl.linux.org>
List-Id: dm-devel.ids

------=_Part_41703_25562570.1164353620337
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 11/24/06, Sandeep Kumar <sandeepksinha@gmail.com> wrote:
>
> Hi all,
>
> #echo 0 100 linear /dev/hdd 0 | dmsetup create new
> #dd if=/dev/zero count=1 of=/dev/mapper/new
>
>
>
> Well, I am trying to get the information printed from the bio structure,
> when the control comes to linear_ctr.
> I found that the control comes to linear_ctr twice.
>
> I have customized the linear_ctr  and have re-compiled the kernel.
>
> Why is that so ?
> Why two times ?


Sorry, its not linear_ctr. Its linear_map.


-- 
> Regards,
> Sandeep
>
>
>
>
>
> Winners expect to win in advance. Life is a self-fulfilling prophecy.




-- 
Regards,
Sandeep





Winners expect to win in advance. Life is a self-fulfilling prophecy.

------=_Part_41703_25562570.1164353620337
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div><span class="gmail_quote">On 11/24/06, <b class="gmail_sendername">Sandeep Kumar</b> &lt;<a href="mailto:sandeepksinha@gmail.com">sandeepksinha@gmail.com</a>&gt; wrote:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi all,<br><br>#echo 0 100 linear /dev/hdd 0 | dmsetup create new<br>#dd if=/dev/zero count=1 of=/dev/mapper/new <br><br><br><br>Well, I am trying to get the information printed from the bio structure, when the control comes to linear_ctr.
<br>I found that the control comes to linear_ctr twice.<br><br>I have customized the linear_ctr&nbsp; and have re-compiled the kernel.<br><br>Why is that so ?<br>Why two times ?</blockquote><div><br>Sorry, its not linear_ctr. Its linear_map.
<br>&nbsp;</div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">-- <br>Regards,<br>Sandeep<br>
<br><br><br><br><br>Winners expect to win in advance. Life is a self-fulfilling prophecy.

</blockquote></div><br><br clear="all"><br>-- <br>Regards,<br>Sandeep<br><br><br><br><br><br>Winners expect to win in advance. Life is a self-fulfilling prophecy.

------=_Part_41703_25562570.1164353620337--

--
Kernelnewbies: Help each other learn about the Linux kernel.
Archive:       http://mail.nl.linux.org/kernelnewbies/
FAQ:           http://kernelnewbies.org/faq/
