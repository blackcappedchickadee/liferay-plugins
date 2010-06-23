<%
/**
 * Copyright (c) 2000-2010 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
%>

<%@ include file="/aggregator/init.jsp" %>

<%
String tabs2 = ParamUtil.getString(request, "tabs2", "display-settings");

List<Article> articles = KnowledgeBaseUtil.getArticles(resourcePrimKeys, QueryUtil.ALL_POS, QueryUtil.ALL_POS, false);
%>

<liferay-portlet:renderURL portletConfiguration="true" var="portletURL">
	<portlet:param name="tabs2" value="<%= tabs2 %>" />
</liferay-portlet:renderURL>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL" />

<aui:form action="<%= configurationURL %>" method="post" name="fm">
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input name="tabs2" type="hidden" value="<%= tabs2 %>" />
	<aui:input name="resourcePrimKeys" type="hidden" value='<%= ListUtil.toString(articles, "resourcePrimKey") %>' />

	<liferay-ui:tabs
		names="display-settings,selection-method,rss"
		param="tabs2"
		url="<%= portletURL %>"
	/>

	<aui:fieldset>
		<c:choose>
			<c:when test='<%= tabs2.equals("display-settings") %>'>
				<aui:input cssClass="lfr-input-text-container" label="title" name="articlesTitle" value="<%= articlesTitle %>" />

				<aui:select label="maximum-items-to-display" name="articlesDelta">
					<aui:option label="1" selected="<%= articlesDelta == 1 %>" />
					<aui:option label="2" selected="<%= articlesDelta == 2 %>" />
					<aui:option label="3" selected="<%= articlesDelta == 3 %>" />
					<aui:option label="4" selected="<%= articlesDelta == 4 %>" />
					<aui:option label="5" selected="<%= articlesDelta == 5 %>" />
					<aui:option label="10" selected="<%= articlesDelta == 10 %>" />
					<aui:option label="15" selected="<%= articlesDelta == 15 %>" />
					<aui:option label="20" selected="<%= articlesDelta == 20 %>" />
					<aui:option label="25" selected="<%= articlesDelta == 25 %>" />
					<aui:option label="30" selected="<%= articlesDelta == 30 %>" />
					<aui:option label="40" selected="<%= articlesDelta == 40 %>" />
					<aui:option label="50" selected="<%= articlesDelta == 50 %>" />
					<aui:option label="60" selected="<%= articlesDelta == 60 %>" />
					<aui:option label="70" selected="<%= articlesDelta == 70 %>" />
					<aui:option label="80" selected="<%= articlesDelta == 80 %>" />
					<aui:option label="90" selected="<%= articlesDelta == 90 %>" />
					<aui:option label="100" selected="<%= articlesDelta == 100 %>" />
				</aui:select>

				<aui:select name="articlesDisplayStyle">
					<aui:option label="<%= RSSUtil.DISPLAY_STYLE_ABSTRACT %>" selected="<%= articlesDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_ABSTRACT) %>" />
					<aui:option label="<%= RSSUtil.DISPLAY_STYLE_FULL_CONTENT %>" selected="<%= articlesDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_FULL_CONTENT) %>" />
					<aui:option label="<%= RSSUtil.DISPLAY_STYLE_TITLE %>" selected="<%= articlesDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_TITLE) %>" />
				</aui:select>

				<aui:select name="articleWindowState">
					<aui:option label="maximized" selected="<%= articleWindowState.equals(WindowState.MAXIMIZED.toString()) %>" value="<%= WindowState.MAXIMIZED.toString() %>" />
					<aui:option label="normal" selected="<%= articleWindowState.equals(WindowState.NORMAL.toString()) %>" value="<%= WindowState.NORMAL.toString() %>" />
				</aui:select>

				<aui:select name="childArticlesDisplayStyle">
					<aui:option label="<%= RSSUtil.DISPLAY_STYLE_ABSTRACT %>" selected="<%= childArticlesDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_ABSTRACT) %>" />
					<aui:option label="<%= RSSUtil.DISPLAY_STYLE_FULL_CONTENT %>" selected="<%= childArticlesDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_FULL_CONTENT) %>" />
					<aui:option label="<%= RSSUtil.DISPLAY_STYLE_TITLE %>" selected="<%= childArticlesDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_TITLE) %>" />
				</aui:select>

				<aui:input inlineLabel="left" label="enable-comments" name="enableArticleComments" type="checkbox" value="<%= enableArticleComments %>" />

				<aui:input inlineLabel="left" label="enable-comment-ratings" name="enableArticleCommentRatings" type="checkbox" value="<%= enableArticleCommentRatings %>" />
			</c:when>
			<c:when test='<%= tabs2.equals("selection-method") %>'>

				<%
				String taglibOnChange = renderResponse.getNamespace() + "updateSelectionMethod(this.value);";
				%>

				<aui:select name="selectionMethod" onChange="<%= taglibOnChange %>">
					<aui:option label="articles" selected='<%= selectionMethod.equals("articles") %>' />
					<aui:option label='<%= "this-" + (themeDisplay.getScopeGroup().isOrganization() ? "organization" : "community") %>' selected='<%= selectionMethod.equals("parent-group") %>' value="parent-group" />
				</aui:select>

				<div class="kb-field-wrapper" id="<portlet:namespace />articlesSelectionOptions">
					<aui:field-wrapper label="articles">
						<div class="kb-selected-entries" id="<portlet:namespace />articles">

							<%
							for (Article article : articles) {
							%>

								<span id="<portlet:namespace />article<%= article.getResourcePrimKey() %>"><%= article.getTitle() %></span>

							<%
							}
							%>

						</div>

						<liferay-portlet:renderURL portletName="<%= portletResource %>" var="selectArticlesURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
							<portlet:param name="jspPage" value="/aggregator/select_articles.jsp" />
						</liferay-portlet:renderURL>

						<%
						String taglibOnClick = "var selectArticlesWindow = window.open('" + selectArticlesURL + "', 'selectArticles', 'directories=no,height=640,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=680'); void(''); selectArticlesWindow.focus();";
						%>

						<div class="kb-edit-link">
							<aui:a href="javascript:;" onClick="<%= taglibOnClick %>"><liferay-ui:message key="select-articles" /> &raquo;</aui:a>
						</div>
					</aui:field-wrapper>
				</div>

				<div class="kb-field-wrapper" id="<portlet:namespace />sortOptions">
					<aui:field-wrapper label="options">
						<aui:select inlineField="<%= true %>" label="" name="allArticles">
							<aui:option label="all-articles" selected="<%= allArticles %>" value="<%= true %>" />
							<aui:option label="root-articles" selected="<%= !allArticles %>" value="<%= false %>" />
						</aui:select>

						<aui:select inlineField="<%= true %>" inlineLabel="left" label="order-by" name="orderByColumn">
							<aui:option label="create-date" selected='<%= orderByColumn.equals("create-date") %>' />
							<aui:option label="modified-date" selected='<%= orderByColumn.equals("modified-date") %>' />
							<aui:option label="priority" selected='<%= orderByColumn.equals("priority") %>' />
							<aui:option label="title" selected='<%= orderByColumn.equals("title") %>' />
						</aui:select>

						<aui:select inlineField="<%= true %>" label="" name="orderByAscending">
							<aui:option label="ascending" selected="<%= orderByAscending %>" value="<%= true %>" />
							<aui:option label="descending" selected="<%= !orderByAscending %>" value="<%= false %>" />
						</aui:select>
					</aui:field-wrapper>
				</div>
			</c:when>
			<c:when test='<%= tabs2.equals("rss") %>'>
				Placeholder
			</c:when>
		</c:choose>

		<aui:button-row>
			<aui:button type="submit" />
		</aui:button-row>
	</aui:fieldset>
</aui:form>

<c:if test='<%= tabs2.equals("selection-method") %>'>
	<aui:script>
		function <portlet:namespace />selectArticles(resourcePrimKeys, titles) {
			document.<portlet:namespace />fm.<portlet:namespace />resourcePrimKeys.value = resourcePrimKeys.join();
			document.getElementById("<portlet:namespace />articles").innerHTML = "";

			var articlesElement = document.getElementById("<portlet:namespace />articles");

			for (var i = 0; i < titles.length; i++) {
				var articleElement = document.createElement("span");

				articleElement.id = "<portlet:namespace />article" + resourcePrimKeys[i];
				articleElement.innerHTML = titles[i];

				articlesElement.appendChild(articleElement);
			}
		}

		function <portlet:namespace />updateSelectionMethod(value) {
			if (value == "articles") {
				document.getElementById("<portlet:namespace />articlesSelectionOptions").style.display = "";
				document.getElementById("<portlet:namespace />sortOptions").style.display = "none";
			}
			else if (value == "parent-group") {
				document.getElementById("<portlet:namespace />articlesSelectionOptions").style.display = "none";
				document.getElementById("<portlet:namespace />sortOptions").style.display = "";
			}
		}

		<portlet:namespace />updateSelectionMethod("<%= selectionMethod %>");
	</aui:script>
</c:if>