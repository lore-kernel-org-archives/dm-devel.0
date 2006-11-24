From: "Sandeep Kumar" <sandeepksinha@gmail.com>
Subject: doubt about linear_ctr
Date: Fri, 24 Nov 2006 12:56:21 +0530
Message-ID: <37d33d830611232326i1aefbfa6v86aa97ec6696792@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_Part_41639_4960363.1164353181986"
Return-path: <kernelnewbies-bounce@nl.linux.org>
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

------=_Part_41639_4960363.1164353181986
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

#echo 0 100 linear /dev/hdd 0 | dmsetup create new
#dd if=/dev/zero count=1 of=/dev/mapper/new



Well, I am trying to get the information printed from the bio structure,
when the control comes to linear_ctr.
I found that the control comes to linear_ctr twice.

I have customized the linear_ctr  and have re-compiled the kernel.

Why is that so ?
Why two times ?

-- 
Regards,
Sandeep





Winners expect to win in advance. Life is a self-fulfilling prophecy.

------=_Part_41639_4960363.1164353181986
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,<br><br>#echo 0 100 linear /dev/hdd 0 | dmsetup create new<br>#dd if=/dev/zero count=1 of=/dev/mapper/new <br><br><br><br>Well, I am trying to get the information printed from the bio structure, when the control comes to linear_ctr.
<br>I found that the control comes to linear_ctr twice.<br><br>I have customized the linear_ctr&nbsp; and have re-compiled the kernel.<br><br>Why is that so ?<br>Why two times ?<br clear="all"><br>-- <br>Regards,<br>Sandeep<br>
<br><br><br><br><br>Winners expect to win in advance. Life is a self-fulfilling prophecy.

------=_Part_41639_4960363.1164353181986--

--
Kernelnewbies: Help each other learn about the Linux kernel.
Archive:       http://mail.nl.linux.org/kernelnewbies/
FAQ:           http://kernelnewbies.org/faq/
