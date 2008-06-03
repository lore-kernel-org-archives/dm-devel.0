From: "Laurent GEHLEN" <list.4.gehlen@gmail.com>
Subject: Re: domap (0) failure for create/reload map
Date: Tue, 3 Jun 2008 11:01:27 +0200
Message-ID: <cbca94860806030201l6dbee6ceh26f356f0109d0650@mail.gmail.com>
References: <cbca94860805230258l48eaf9a9u4d4b1ee91ed79294@mail.gmail.com>
	<cbca94860805240247g49712dc5sd93d862bc4ce12a1@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2142984666=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cbca94860805240247g49712dc5sd93d862bc4ce12a1@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2142984666==
Content-Type: multipart/alternative;
	boundary="----=_Part_6912_11789025.1212483687578"

------=_Part_6912_11789025.1212483687578
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I've find some more info in my /var/log/syslog:
    kernel: device-mapper: table: 253:12: multipath: error getting device
    kernel: device-mapper: ioctl: error adding target to table

Still no clue ?

Laurent

2008/5/24 Laurent GEHLEN <list.4.gehlen@gmail.com>:

> I've just seen that the link are dead, so I uploaded the file on my server.
>
> So now you can find the output of multipath -v3 here:
>  --> http://xen-lo.no-ip.org/temp/output-multipath-v3
> And my multipath.conf here:
>  --> http://xen-lo.no-ip.org/temp/multipath.conf
> <http://rafb.net/p/J45SFA12.html>
> Thanks
>
> Laurent
>
> 2008/5/23 Laurent GEHLEN <list.4.gehlen@gmail.com>:
>
> Hello,
>>
>> Is there anybody who can help me to find where is my problem.
>> I'm trying to generate a mapper device with the tools multipath. But
>> visibly it blocs before it finish, because I don't have any new mapper
>> device.
>> When i chose the verbose level 3 i can see those interesting things:
>>
>>> # multipath -v3
>>> [...]
>>> sda: not found in pathvec
>>> [...]
>>> sdb: not found in pathvec
>>> [...]
>>> sdc: not found in pathvec
>>> [...]
>>> sdd: not found in pathvec
>>> [...]
>>> test: set ACT_CREATE (map does not exist)
>>> test: domap (0) failure for create/reload map
>>> [...]
>>> libdevmapper: libdm-common.c(239): Setting SELinux context for
>>> /dev/mapper/test to system_u:object_r:fixed_disk_device_t.
>>> [...]
>>>
>>
>> I think the most interesting thing is the "domap (0) failure for
>> create/reload map".
>> I've read a bit about the code mutlipath
>> (cm/linux/storage/multipath-tools/libmultipath/configure.c+domap+(0)+failure+for+create/reload+map&hl=fr&ct=clnk&cd=4&gl=be&client=firefox-a)
>> And conclude (but not sure) that's the dm_addmap failed.
>>
>> you can find the output of multipath -v3 here:
>>  --> http://rafb.net/p/J45SFA12.html
>>
>> My multipath.conf here:
>>  --> http://rafb.net/p/G66QZ826.html
>>
>> Thank you in advance for any idea!
>>
>> Laurent
>>
>>
>

------=_Part_6912_11789025.1212483687578
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I&#39;ve find some more info in my /var/log/syslog:<br>&nbsp;&nbsp;&nbsp; kernel: device-mapper: table: 253:12: multipath: error getting device<br>&nbsp;&nbsp;&nbsp; kernel: device-mapper: ioctl: error adding target to table<br><br>Still no clue ?<br><br>
Laurent<br><br><div class="gmail_quote">2008/5/24 Laurent GEHLEN &lt;<a href="mailto:list.4.gehlen@gmail.com">list.4.gehlen@gmail.com</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I&#39;ve just seen that the link are dead, so I uploaded the file on my server.<br><br>So now you can find the output of multipath -v3 here:<br>&nbsp;--&gt; <a href="http://xen-lo.no-ip.org/temp/output-multipath-v3" target="_blank">http://xen-lo.no-ip.org/temp/output-multipath-v3</a><br>

And my multipath.conf here:<br>&nbsp;--&gt; <a href="http://xen-lo.no-ip.org/temp/multipath.conf" target="_blank">http://xen-lo.no-ip.org/temp/multipath.conf</a><br><a href="http://rafb.net/p/J45SFA12.html" target="_blank"></a><br>
Thanks<br><br>
Laurent<br><br><div class="gmail_quote">2008/5/23 Laurent GEHLEN &lt;<a href="mailto:list.4.gehlen@gmail.com" target="_blank">list.4.gehlen@gmail.com</a>&gt;:<div><div></div><div class="Wj3C7c"><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

Hello,<br><br>Is there anybody who can help me to find where is my problem.<br>I&#39;m trying to generate a mapper device with the tools multipath. But visibly it blocs before it finish, because I don&#39;t have any new mapper device.<br>



When i chose the verbose level 3 i can see those interesting things:<br><blockquote style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;" class="gmail_quote"># multipath -v3<br>


[...]<br>
sda: not found in pathvec<br>[...]<br>sdb: not found in pathvec<br>[...]<br>sdc: not found in pathvec<br>[...]<br>sdd: not found in pathvec<br>[...]<br>test: set ACT_CREATE (map does not exist)<br>test: domap (0) failure for create/reload map<br>



[...]<br>libdevmapper: libdm-common.c(239): Setting SELinux context for /dev/mapper/test to system_u:object_r:fixed_disk_device_t.<br>[...]<br></blockquote><br>I think the most interesting thing is the &quot;domap (0) failure for create/reload map&quot;.<br>



I&#39;ve read a bit about the code mutlipath (cm/linux/storage/multipath-tools/libmultipath/configure.c+domap+(0)+failure+for+create/reload+map&amp;hl=fr&amp;ct=clnk&amp;cd=4&amp;gl=be&amp;client=firefox-a)<br>And conclude (but not sure) that&#39;s the dm_addmap failed.<br>



<br>you can find the output of multipath -v3 here:<br>&nbsp;--&gt; <a href="http://rafb.net/p/J45SFA12.html" target="_blank">http://rafb.net/p/J45SFA12.html</a><br><br>My multipath.conf here:<br>&nbsp;--&gt; <a href="http://rafb.net/p/G66QZ826.html" target="_blank">http://rafb.net/p/G66QZ826.html</a><br>



<br>Thank you in advance for any idea!<br><font color="#888888"><br>Laurent<br><br>
</font></blockquote></div></div></div><br>
</blockquote></div><br>

------=_Part_6912_11789025.1212483687578--


--===============2142984666==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2142984666==--
